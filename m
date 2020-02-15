Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A45015FFF6
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 20:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgBOTLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 14:11:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32553 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726209AbgBOTLt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 15 Feb 2020 14:11:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581793907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZ9r/oBZwZQJSFS9KT9wcCzoJjtsGACoOSPPGOIDHh0=;
        b=GlADqL7K9VwOYectseYoYvJt6ZaZDOEcv7pmg/1Lt1YNp18GwyN+fOuLwTz7nfWMNjyYRt
        QBqIzbDdni3CgUwXR6erf8hTxrZwZbrF9zzwIo1NoVFf8Ef1s4is1uQOA2KTEstEYhnj8u
        SqDj1tx1I12zubZDYBqNx3MmBOA+li0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-0sp38ZgGPa2ABCbeOiwuYQ-1; Sat, 15 Feb 2020 14:11:45 -0500
X-MC-Unique: 0sp38ZgGPa2ABCbeOiwuYQ-1
Received: by mail-qt1-f199.google.com with SMTP id e37so8221767qtk.7
        for <kvm@vger.kernel.org>; Sat, 15 Feb 2020 11:11:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EZ9r/oBZwZQJSFS9KT9wcCzoJjtsGACoOSPPGOIDHh0=;
        b=AjFM/Tb3O1hfQzWZOOXqWmjL61ym2EOIhxvjLlk+tcNDZ/dvjE+Yrs7YoUAPIsr54C
         9F4BVvoUATs8O22kDWvkLa+z2qjJvn8+bqKyNZFROMEMUClqt0Zh31ryGZRjkKgrQeH5
         ejHSE3tUDwOIsR6kBJFsNDwnaGNcPmr4KqW0W3ZOZSVgsDWT7SLGm+CA4iUX0ntsiJct
         2aMvphxnKDo8eZu5Oaye0c0IZj/2i/KViX1W/dW5x+QrGU9NhXRuHCPX3tvrxdDIreUs
         QtBEiukxGu3GiBkB2AmvFhWI81x70YsHfV7PwUErk4wTBnfgsKXsAdMrKvcnYyCtb2ts
         /wNg==
X-Gm-Message-State: APjAAAXegjXK09ejS1FMYgNu8d4qYSgunM+4hhychaNBFM4NaR73Qryo
        BXV20WAyBoJUx+M5bNhlOW8mrEHez0nO4f2ZpoHtrV0r/nXT54Nc/wlKjmj9fu3ePdiU7SXua3P
        t8iK3wNrXmShu
X-Received: by 2002:a0c:e8c7:: with SMTP id m7mr7243134qvo.128.1581793904938;
        Sat, 15 Feb 2020 11:11:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqy8mQRiagTE+HIsLhJeYgynAu0GcjDD9kJvzBjwWMBb+VAwfV2vAD1fLgDha/5MOJzcSrUUPw==
X-Received: by 2002:a0c:e8c7:: with SMTP id m7mr7243119qvo.128.1581793904684;
        Sat, 15 Feb 2020 11:11:44 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id t55sm6272393qte.24.2020.02.15.11.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 11:11:43 -0800 (PST)
Date:   Sat, 15 Feb 2020 14:11:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH 00/13] KVM: selftests: Various fixes and cleanups
Message-ID: <20200215190900.GC1195634@xz-x1>
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214222639.GB1195634@xz-x1>
 <20200215070752.4fcymg7ruarfc4fc@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200215070752.4fcymg7ruarfc4fc@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 15, 2020 at 08:07:52AM +0100, Andrew Jones wrote:
> On Fri, Feb 14, 2020 at 05:26:39PM -0500, Peter Xu wrote:
> > On Fri, Feb 14, 2020 at 03:59:07PM +0100, Andrew Jones wrote:
> > > This series has several parts:
> > > 
> > >  * First, a hack to get x86 to compile. The missing __NR_userfaultfd
> > >    define should be fixed a better way.
> > 
> > Yeh otherwise I think it will only compile on x86_64.
> 
> The opposite for me. I could compile on AArch64 without this hack, but on
> x86 (my Fedora 30 laptop) I could not.

Ah, then probably because ARM does not have that artificial unisted*.h
defined (tools/arch/x86/include/asm/unistd_{32|64}.h for x86), then
<sys/syscall.h> can find the correct headers.

And I have said it wrong above... with patch 1 compilation should
always work, but IIUC the syscall number will be wrong on 32bit
systems.  Maybe we still need the other solution to make the test
runnable on all platforms by removing those two artificial headers.

Thanks,

-- 
Peter Xu

