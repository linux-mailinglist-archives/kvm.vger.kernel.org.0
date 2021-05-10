Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B34377C47
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEJGdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:33:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229863AbhEJGdp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 02:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620628361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1xp5CXeApoBRGIrJIKufW+mRSz5wk+uC5rFnWxgQ3fE=;
        b=h3l6U7Yz6GRfRdK5lODJ4+j6t2onsR7fvloKnbJ15jEIJ2CTEFkA43APj0lZOI7h7SJ7gO
        raJM8ydqGQEtDQxaXcEE7sZbHQqig5gsmQIHtNV+adPPFXpkF3tO8K+H6NiA1n65VRYAuL
        ACKGjXMbdRRo6Nn0B37nF3nLfnuco04=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-wbsZF2DqMUW2UQvLbqobkA-1; Mon, 10 May 2021 02:32:39 -0400
X-MC-Unique: wbsZF2DqMUW2UQvLbqobkA-1
Received: by mail-ej1-f69.google.com with SMTP id z15-20020a170906074fb029038ca4d43d48so4349896ejb.17
        for <kvm@vger.kernel.org>; Sun, 09 May 2021 23:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1xp5CXeApoBRGIrJIKufW+mRSz5wk+uC5rFnWxgQ3fE=;
        b=eyTb032Ku1eHfiB+/dY5+5vtLS19QJmoTzY//e/zJmy0Fo5vRDDEXHrt6an5Bnd0Pd
         gJdz0ygdqegyUgOBQ427/f4WAVcimcQLWQQJTAlQBByqCT8deOYUnZsCT24oB6trw775
         rIVi1S50JGWn290x3r2jch3SP0cTM1Pgrg4Yn3GXMaW4TOxFUEi+XfHecVGS8ZtFQFUE
         liltXGW32eyliR3vhr7qtNi3Lqj3J+hP1ficpcmxVRSYh1i2O2PSXH9M5o6ge0mivemq
         Vy1l2cQUrC2WU/ZKwyLNh3/TpEe+SHnFUmg29KtJIXUsPU+h/UvCm3xQwQvq7BXM3P71
         EXbw==
X-Gm-Message-State: AOAM532KLW2LOUnIDm3Pze0SXlUduxILoX8ngGiqo0fCIren0IeEUrL8
        YmHTf/JgPlozoap5N1v/I1kN2jISAbpMygLsDQ4Kkc/pIiFVDDPjpFAiioIzbU7GHqc0WPpIZfn
        EIXOWpWHMIBss
X-Received: by 2002:a17:906:5a83:: with SMTP id l3mr24066569ejq.50.1620628358538;
        Sun, 09 May 2021 23:32:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypEhn8R0VJeNzMsaV7jR0XKiODWQvEf+ed6g2SLE5v0Oabap0gb0tBkuQ74d/zsgTSP6hqag==
X-Received: by 2002:a17:906:5a83:: with SMTP id l3mr24066558ejq.50.1620628358430;
        Sun, 09 May 2021 23:32:38 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id z7sm10494841edi.39.2021.05.09.23.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:32:38 -0700 (PDT)
Date:   Mon, 10 May 2021 08:32:36 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH] KVM: selftests: Print a message if /dev/kvm is missing
Message-ID: <20210510063236.5ekmlulazelvl2s6@gator>
References: <20210507190559.425518-1-dmatlack@google.com>
 <20210507201443.nvtmntp3tgeapwnw@gator.home>
 <CALzav=dk_Z=hQE1Bjpfg8B3su7h2Jvk6RZoEFqBn+qqxmwzHMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dk_Z=hQE1Bjpfg8B3su7h2Jvk6RZoEFqBn+qqxmwzHMQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 01:51:45PM -0700, David Matlack wrote:
> > >  static void vm_open(struct kvm_vm *vm, int perm)
> > >  {
> > > -     vm->kvm_fd = open(KVM_DEV_PATH, perm);
> >
> > I don't think we should change this one, otherwise the user provided
> > perms are ignored.
> 
> Good catch. I don't see any reason to exclude this case, but we do need
> to pass `perm` down to open_kvm_dev_path_or_exit().
>

I've reviewed v2 and gave it an r-b, since I don't have overly strong
opinion about this, but I actually liked that open_kvm_dev_path_or_exit()
didn't take any arguments. To handle this case I would have either left
it open coded, like it was, or created something like

int _open_kvm_dev_path_or_exit(int flags)
{
   int fd = open(KVM_DEV_PATH, flags);
   if (fd < 0)
     ...exit skip...
   return fd;
}

int open_kvm_dev_path_or_exit(void)
{
  return _open_kvm_dev_path_or_exit(O_RDONLY);
}

Thanks,
drew

